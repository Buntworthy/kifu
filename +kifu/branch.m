function branch(branchName, commitMessage)
    [code, b] = system(sprintf('git checkout -b %s', branchName)); % tag should be unique
    if code ~= 0
        error('kifu:branchExists', ...
                'Branch all exists with name ''%s''.', branchName);
    end
    [a, b] = system('git add -u'); % add everything
    [a, b] = system(sprintf('git commit -m "%s"', commitMessage));
end