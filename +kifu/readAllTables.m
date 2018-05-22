function fullTable = readAllTables(project)
    
    fullTable = table();
    folderPath = kifu.Logger.makePath(project);
    logFiles = dir(fullfile(folderPath, '*.csv'));
    for iFile = 1:numel(logFiles)
        thisFile = logFiles(iFile).name;
        t = readtable(fullfile(folderPath, thisFile));
        t.Filename(:) = string(thisFile);
        t = movevars(t, 'Filename', 'Before', 1);
        if isempty(fullTable)
            fullTable = t;
        else
            fullTable = [fullTable; t];
        end
    end
end