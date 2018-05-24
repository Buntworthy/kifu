results = kifu.readAllTables('');
[fileId, filenames] = findgroups(results.Filename);

Y = splitapply(@min, results.TrainingLoss, fileId);
% Y = splitapply(@min, results.ValidationLoss, fileId);
bar(Y)
%%
figure
hold on
for filename = filenames'
    plot(results.Iteration(results.Filename == filename, :), ...
            results.TrainingLoss(results.Filename == filename, :));
end
grid on
legend(filenames, 'Interpreter', 'none')
xlabel('Iteration')
ylabel('TrainingLoss')

%%
figure
hold on
for filename = filenames'
    selected = results.Filename == filename & ~isnan(results.ValidationAccuracy);
    plot(results.Iteration(selected, :), ...
            results.ValidationAccuracy(selected, :));
end
grid on
legend(filenames, 'Interpreter', 'none')
xlabel('Iteration')
ylabel('Val acc')