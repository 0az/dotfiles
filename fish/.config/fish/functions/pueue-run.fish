function pueue-run
    test -n "$argv" || return 1
    echo pueue add --print-task-id $argv >&2
    set -l task_id (pueue add --print-task-id $argv) || return $status
    pueue wait --status Running $task_id
    pueue follow $task_id
end
