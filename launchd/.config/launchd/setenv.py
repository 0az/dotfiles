#! /usr/bin/python
from __future__ import print_function

import argparse
import logging
from logging import StreamHandler
from logging.handlers import SysLogHandler
import pprint
import shlex
import string
import subprocess
import sys
import os

ALPHABET = frozenset(string.ascii_letters)
IDENTIFIER_START = ALPHABET | set('_')
IDENTIFIER = IDENTIFIER_START | set(string.digits)

logger = logging.getLogger()
syslog_sock = None
if os.path.exists('/var/run/syslog'):
    syslog_sock = '/var/run/syslog'
elif os.path.exists('/dev/log'):
    syslog_sock = '/dev/log'

logger.setLevel(logging.DEBUG)
logger.addHandler(StreamHandler(sys.stdout))
if syslog_sock:
    logger.addHandler(SysLogHandler(syslog_sock))


def validate_name(name):
    if not name:
        return False
    if not name[0] in IDENTIFIER_START:
        return False
    if not set(name) <= IDENTIFIER:
        return False
    return True


def sanitize_name(name):
    name = name.strip()
    if not validate_name(name):
        raise ValueError('Invalid Name')
    return name


def process_value(value):
    if not value:
        return ''
    if value.isspace():
        logger.warn(
            'Value %s consists solely of spaces - is this a bug?' % repr(value)
        )
        logger.warn(
            'Replacing whitespace value %s with empty string' % repr(value)
        )
        return ''
    orig = value
    if value[0].isspace():
        logger.warn('Stripping leading space in value=%s' % repr(orig))
        value = value.lstrip()
    if value[-1].isspace():
        logger.warn('Stripping trailing space in value=%s' % repr(orig))
        value = value.rstrip()
    words = shlex.split(value)
    if len(words) > 1:
        logger.warn(
            'Value %s splits to multiple arguments, joining' % repr(orig)
        )
    else:
        value = words[0]
    result = os.path.expandvars(value)
    result = os.path.expanduser(result)
    return result


def post_process(name, value):
    folded = name.upper().lower()
    if folded == 'PATH':
        lst = value.split(':')
        value = ':'.join(os.path.expanduser(elem) for elem in lst)
    os.environ[name] = value
    return name, value


def process_line(line):
    if not line.strip() or line.startswith('#'):
        return None, None
    tup = line.strip().split('=', 1)
    if len(tup) < 2:
        raise ValueError("Missing '=' in line %s" % repr(line))
    name, value = tup
    if not validate_name(name):
        try:
            name = sanitize_name()
            logger.warning(
                'Sanitized invalid line: name=%s, value=%s'
                % (repr(name), repr(value))
            )
        except ValueError:
            logger.error(
                'Skipping invalid line: name=%s, value=%s'
                % (repr(name), repr(value))
            )
            return None, None

    value = process_value(value)
    name, value = post_process(name, value)
    return name, value


def main():
    logger.info('Starting setenv script')
    env = {name: val for name, val in os.environ.items() if name in ('HOME')}
    os.environ.clear()
    for name, val in env.items():
        os.environ[name] = val
    s = pprint.pformat(os.environ)
    logger.debug(s)

    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--dry-run', action='store_true')

    args = parser.parse_args()
    directory = os.path.dirname(__file__) or '.'
    invocation = ['/bin/launchctl', 'setenv']

    with open(os.path.join(directory, 'launchd.env')) as f:
        for line in f:
            name, value = process_line(line)
            if not name:
                continue
            invocation.append(name)
            invocation.append(value)
    level = logging.INFO if args.dry_run else logging.DEBUG
    for name, value in zip(invocation[2::2], invocation[3::2]):
        logger.log(level, '%s=%s' % (name, repr(value)))
    s = pprint.pformat(os.environ)
    logger.debug(s)
    if args.dry_run:
        return 0
    return subprocess.call(invocation)


if __name__ == '__main__':
    sys.exit(main())
