function functionHandle = log()
    logger = kifu.Logger('', '');
    functionHandle = @logger.log;
end