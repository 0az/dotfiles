def Settings(client_data: dict, **kwargs):
    return {
        'interpreter_path': client_data['g:ycm_python_interpreter_path'],
        'sys_path': client_data['g:ycm_python_sys_path'],
    }
