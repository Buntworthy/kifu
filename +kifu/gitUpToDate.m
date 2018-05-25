function tf = gitUpToDate()
    [a, b] = system('git status --porcelain');
    if isempty(b)
        tf = true;
    else
        tf = false;
    end
end