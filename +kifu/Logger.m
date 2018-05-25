classdef Logger < handle
    
    properties
        Project
        Tag
        Filename
        Path
        FullPath
        UseGit
        Note = ''
        Branched = false
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
        function obj = Logger(project, tag, useGit, note)
            obj.Project = project;
            obj.Tag = tag;
            obj.UseGit = useGit;
            obj.Note = note;
            % TODO wait until fully configured
            if obj.UseGit
                obj.createBranch();
            end
            obj.Filename = obj.makeFilename(tag);
            obj.Path = obj.makePath(project);
            obj.FullPath = fullfile(obj.Path, obj.Filename);
            obj.initialiseFile();
        end
        
        function delete(obj)
            if obj.Branched
                % TODO check status
                [a, b] = system('git checkout master');
            end
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
    
        function filename = makeFilename(obj, tag)
            now = datetime('now');
            dateString = datestr(now, 'yyyymmdd_HHMMSS');
            filename = sprintf('%s_%s', dateString, tag);
            if obj.UseGit
                filename = kifu.Logger.addGitHash(filename);
            end
            filename = [filename, '.csv'];
        end
        
        function createBranch(obj)
            assert(~kifu.untrackedFiles, ...
                    'kifu:UntrackedFiles', ...
                    'There are untracked files in the git repo.');
            
            if kifu.gitUpToDate() % up to date
                % Don't do anything?
            else
                kifu.branch(obj.Tag, obj.Note);
                obj.Branched = true;
            end
        end
        
    end
    
    methods (Static)
        
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
