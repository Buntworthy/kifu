function logger = getLogger(tag)

    directory = '.kifu';
    if ~isdir(directory)
        mkdir(directory)
    end

    now = datetime('now');
    dateString = datestr(now, 'yyyymmdd_HHMMSS');

    [code, hash] = system('git rev-parse --short HEAD');
    if code == 255 % not a git repo
        hashString = 'make your own';
    else
        hashString = strip(hash);
    end

    filename = sprintf('%s_%s.csv', dateString, tag);

    writeHeader(fullfile(directory, filename));

    logger = @(output) kifu.makeLogger(fullfile(directory, filename), output);

end

function writeHeader(filename)
    logId = fopen(filename, 'at');
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
    format = repmat('%s,', 1, numel(headers));
    format = [format(1:end-1), '\n'];
    fprintf(logId, format, headers{:});
end
