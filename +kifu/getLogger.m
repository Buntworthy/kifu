function logger = getLogger(output)

    now = datetime('now');
    dateString = datestr(now, 'yyymmdd_HHMMSS');
    disp(output.ValidationAccuracy);

end
