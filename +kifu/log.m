function functionHandle = log()
    % Get the current logger, or make a new one
    logger = kifu.Logger.getInstance();
    functionHandle = @logger.log;
end