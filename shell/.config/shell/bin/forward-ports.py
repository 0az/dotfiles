#! /usr/bin/env python3

from __future__ import annotations

import os
import sys


# TODO: Add support for port ranges
# TODO: Add support for extra

def parse_arg(s: str) -> tuple[int, int]:
    if ':' not in s:
        p = int(s)
        return p, p

    local, remote = s.split(':', 1)
    return int(local), int(remote)


def main(argv: list[str]) -> int:
    ports = {}

    for i, arg in enumerate(argv[1:], 1):
        if arg == '--':
            i += 1
            break
        l, r = parse_arg(arg)
        ports[l] = r

    args = [
        'ssh',
        '-N',
        '-o',
        'ExitOnForwardFailure=yes',
    ]
    for l, r in ports.items():
        args.append('-L')
        args.append(f'127.0.0.1:{l}:127.0.0.1:{r}')

    if i < len(argv):
        args.extend(argv[i:])

    os.execvp('ssh', args)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
