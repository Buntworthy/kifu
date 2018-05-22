classdef Logger < handle
    
    properties
        Project
        Tag
        Filename
        Path
        FullPath
    end
    
    properties (Constant)
        Headers = {...
                    'Epoch', ...
                    'Iteration', ...
                    'TimeSinceStart', ...
                    'TrainingLoss', ...
                    'ValidationLoss', ...
                    'BaseLearnRate', ...
                    'TrainingAccuracy', ...
                    'TrainingRMSE', ...
                    'ValidationAccuracy', ...
                    'ValidationRMSE', ...
                    'State'};
        Root = '.kifu';
    end
    
    methods
        function obj = Logger(project, tag)
            obj.Project = project;
            obj.Tag = tag;
            obj.Filename = obj.makeFilename(tag);
            obj.Path = obj.makePath(project);
            obj.FullPath = fullfile(obj.Path, obj.Filename);
            obj.initialiseFile();
        end
        
        function initialiseFile(obj)
            if ~isfolder(obj.Path)
                mkdir(obj.Path)
            end
            
            logId = fopen(obj.FullPath, 'at');
            closeFile = onCleanup(@() fclose(logId));
            
            format = repmat('%s,', 1, numel(obj.Headers));
            format = [format(1:end-1), '\n'];
            fprintf(logId, format, obj.Headers{:});
        end
        
        function log(obj, output)
            logId = fopen(obj.FullPath, 'at');
            closeFile = onCleanup(@() fclose(logId));

            for iField = 1:numel(obj.Headers)
                fieldName = obj.Headers{iField};
                if ~isfield(output, fieldName)
                    data = '';
                else
                    data = output.(fieldName);
                end
                if strcmp(fieldName, 'State')
                    fprintf(logId, '%s', data);
                else
                    fprintf(logId, '%f', data);
                end
                
                if iField == numel(obj.Headers)
                    fprintf(logId, '\n');
                else
                    fprintf(logId, ',');
                end
            end
        end
        
    end
    
    methods (Static)
        function filename = makeFilename(tag)
            now = datetime('now');
            dateString = datestr(now, 'yyyymmdd_HHMMSS');
            filename = sprintf('%s_%s', dateString, tag);
            filename = kifu.Logger.addGitHash(filename);
            filename = [filename, '.csv'];
        end
        
        function folderPath = makePath(project)
            folderPath = fullfile(kifu.Logger.Root, project);
        end
        
        function newName = addGitHash(oldName)
            [code, hash] = system('git rev-parse --short HEAD');
            if code ~= 0 % not a git repo
                newName = oldName;
                return
            else
                hashString = strip(hash);
                newName = sprintf('%s_%s', oldName, hashString);
            end
        end
    end
end
