function commit(commitMessage)
    % TODO error checking
    [a, b] = system('git add -u'); % add everything
    [a, b] = system(sprintf('git commit -m "%s"', commitMessage));
end
