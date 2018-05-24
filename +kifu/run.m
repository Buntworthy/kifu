function run(toRun, tag, note)

    logger = kifu.Logger(project, tag, note);
    % TODO store the note in the header?
    toRun();
end