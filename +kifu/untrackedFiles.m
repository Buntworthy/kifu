function tf = untrackedFiles()
    [~, status] = system('git status --porcelain');
    tf = any(startsWith(splitlines(status), '??'));
end