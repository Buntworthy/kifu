classdef GitTest < matlab.unittest.TestCase
    
    methods (Test)
        function testUntrackedFilesTrue(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture;
            testCase.applyFixture(WorkingFolderFixture);
            system('git init');
            dlmwrite('0.txt', rand(10));
            testCase.verifyTrue(kifu.untrackedFiles());
        end
        
        function testUntrackedFilesFalse(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture;
            testCase.applyFixture(WorkingFolderFixture);
            system('git init');
            dlmwrite('0.txt', rand(10));
            system('git add .');
            testCase.verifyFalse(kifu.untrackedFiles());
        end
        
        function testBranch(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture;
            testCase.applyFixture(WorkingFolderFixture);
            system('git init');
            dlmwrite('0.txt', rand(10));
            system('git add .');
            kifu.branch('thing', 'thing');
            
            % TODO check exists
        end
        
        function testBranchExists(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture;
            testCase.applyFixture(WorkingFolderFixture);
            system('git init');
            dlmwrite('0.txt', rand(10));
            system('git add .');
            kifu.branch('thing', 'thing');
            
            branchAgain = @()kifu.branch('thing', 'thing');
            
            testCase.verifyError(branchAgain, 'kifu:branchExists');
        end
        
        function testUptoDate(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture;
            testCase.applyFixture(WorkingFolderFixture);
            system('git init');
            dlmwrite('0.txt', rand(10));
            system('git add .');
            system('git commit -m "message"');
            
            testCase.verifyTrue(kifu.gitUpToDate());
        end
        
        function testNotUptoDate(testCase)
            import matlab.unittest.fixtures.WorkingFolderFixture;
            testCase.applyFixture(WorkingFolderFixture);
            system('git init');
            dlmwrite('0.txt', rand(10));
            system('git add .');
            system('git commit -m "message"');
            dlmwrite('1.txt', rand(10));
            
            testCase.verifyFalse(kifu.gitUpToDate());
            
            system('git add .');
            testCase.verifyFalse(kifu.gitUpToDate());
        end
    end
    
end