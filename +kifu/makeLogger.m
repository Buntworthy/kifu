function makeLogger(filename, output)
% returns the handle to a function to append to the log file

    headers = {...
                'Epoch', ...
                'Iteration', ...
                'TimeSinceStart', ...
                'TrainingLoss', ...
                'ValidationLoss', ...
                'BaseLearnRate', ...
                'TrainingAccuracy', ...
                'TrainingRMSE', ...
                'ValidationAccuracy', ...
                'ValidationRMSE'};

    logId = fopen(filename, 'at');

    for iField = 1:numel(headers)
        fieldName = headers{iField};
        if ~isfield(output, fieldName)
            data = '';
        else
            data = output.(fieldName);
        end
        fprintf(logId, '%f', data);
        if iField == numel(headers)
            fprintf(logId, '\n');
        else
            fprintf(logId, ',');
        end
    end

    fclose(logId);

end

