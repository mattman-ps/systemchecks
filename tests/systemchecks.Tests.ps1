BeforeAll {
    # Import the module
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
    $ModulePath = Join-Path $ProjectRoot 'dist' 'systemchecks' 'systemchecks.psd1'
    Import-Module $ModulePath -Force

    # Create test resources
    $TestDrive = 'TestDrive:\'
    $TestFile = Join-Path $TestDrive 'testfile.txt'
    $TestFolder = Join-Path $TestDrive 'testfolder'
    New-Item -Path $TestFile -ItemType File -Force | Out-Null
    New-Item -Path $TestFolder -ItemType Directory -Force | Out-Null
    1..5 | ForEach-Object { New-Item -Path (Join-Path $TestFolder "file$_.txt") -ItemType File -Force | Out-Null }
}

AfterAll {
    Remove-Module systemchecks -Force -ErrorAction SilentlyContinue
}

Describe 'Module Import' {
    It 'Should import successfully' {
        Get-Module systemchecks | Should -Not -BeNullOrEmpty
    }

    It 'Should have a valid GUID' {
        $module = Get-Module systemchecks
        $module.Guid | Should -Be '08d6810d-5aca-421f-8f3f-c892fa974b7a'
    }

    It 'Should have correct version' {
        $module = Get-Module systemchecks
        $module.Version | Should -Be '0.0.1'
    }

    It 'Should export expected functions' {
        $exportedFunctions = (Get-Command -Module systemchecks).Name
        $expectedFunctions = @(
            'Get-FileCount'
            'Get-SystemHealth'
            'Get-Win32Error'
            'Test-FileExists'
            'Test-ProcessHealth'
            'Test-ScheduledTask'
            'Test-ServiceHealth'
            'Test-ShareExists'
            'Test-TimeSync'
            'Test-URIHealth'
        )
        foreach ($func in $expectedFunctions) {
            $exportedFunctions | Should -Contain $func
        }
    }
}

Describe 'Test-FileExists' {
    Context 'When file exists' {
        It 'Should return Status "Exists"' {
            $result = Test-FileExists -FilePath $TestFile
            $result.Status | Should -Be 'Exists'
        }

        It 'Should return proper Type' {
            $result = Test-FileExists -FilePath $TestFile
            $result.Type | Should -Be 'FileExists'
        }

        It 'Should include the filename in Name property' {
            $result = Test-FileExists -FilePath $TestFile
            $result.Name | Should -Be 'testfile.txt'
        }

        It 'Should include file path in Comment' {
            $result = Test-FileExists -FilePath $TestFile
            $result.Comment | Should -Be $TestFile
        }

        It 'Should include ComputerName' {
            $result = Test-FileExists -FilePath $TestFile
            $result.ComputerName | Should -Be $env:COMPUTERNAME
        }

        It 'Should accept SystemName parameter' {
            $result = Test-FileExists -FilePath $TestFile -SystemName 'TestSystem'
            $result.SystemName | Should -Be 'TestSystem'
        }

        It 'Should accept SystemDescription parameter' {
            $result = Test-FileExists -FilePath $TestFile -SystemDescription 'Test Description'
            $result.SystemDescription | Should -Be 'Test Description'
        }

        It 'Should have a LastUpdate timestamp' {
            $result = Test-FileExists -FilePath $TestFile
            $result.LastUpdate | Should -Not -BeNullOrEmpty
            { [DateTime]::ParseExact($result.LastUpdate, 'yyyy-MM-dd HH:mm:ss', $null) } | Should -Not -Throw
        }
    }

    Context 'When file does not exist' {
        It 'Should return Status "Not Found"' {
            $result = Test-FileExists -FilePath 'C:\NonExistent\File.txt'
            $result.Status | Should -Be 'Not Found'
        }

        It 'Should return proper Type' {
            $result = Test-FileExists -FilePath 'C:\NonExistent\File.txt'
            $result.Type | Should -Be 'FileExists'
        }

        It 'Should include the filename in Name property' {
            $result = Test-FileExists -FilePath 'C:\NonExistent\File.txt'
            $result.Name | Should -Be 'File.txt'
        }
    }

    Context 'Real world scenarios' {
        It 'Should check Windows hosts file' {
            $hostsFile = 'C:\Windows\System32\drivers\etc\hosts'
            if (Test-Path $hostsFile) {
                $result = Test-FileExists -FilePath $hostsFile
                $result.Status | Should -Be 'Exists'
                $result.Name | Should -Be 'hosts'
            }
        }
    }
}

Describe 'Test-ProcessHealth' {
    Context 'When process is running' {
        BeforeAll {
            # PowerShell process should always be running during tests
            $ProcessName = (Get-Process -Id $PID).Name
        }

        It 'Should return Status "Responding"' {
            $result = Test-ProcessHealth -ProcessName $ProcessName
            $result.Status | Should -Be 'Responding'
        }

        It 'Should return proper Type' {
            $result = Test-ProcessHealth -ProcessName $ProcessName
            $result.Type | Should -Be 'Process'
        }

        It 'Should include process name in Name property' {
            $result = Test-ProcessHealth -ProcessName $ProcessName
            $result.Name | Should -Be $ProcessName
        }

        It 'Should include ComputerName' {
            $result = Test-ProcessHealth -ProcessName $ProcessName
            $result.ComputerName | Should -Be $env:COMPUTERNAME
        }

        It 'Should accept SystemName parameter' {
            $result = Test-ProcessHealth -ProcessName $ProcessName -SystemName 'TestSystem'
            $result.SystemName | Should -Be 'TestSystem'
        }
    }

    Context 'When process is not running' {
        It 'Should return Status "ERROR"' {
            $result = Test-ProcessHealth -ProcessName 'NonExistentProcess12345'
            $result.Status | Should -Be 'ERROR'
        }

        It 'Should have error comment' {
            $result = Test-ProcessHealth -ProcessName 'NonExistentProcess12345'
            $result.Comment | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'Test-ServiceHealth' {
    Context 'When service exists and is running' {
        BeforeAll {
            # Find a running service (Windows Time is usually running)
            $RunningService = Get-Service | Where-Object { $_.Status -eq 'Running' } | Select-Object -First 1
        }

        It 'Should return Status "OK" for running service' {
            $result = Test-ServiceHealth -ServiceName $RunningService.Name
            $result.Status | Should -Be 'OK'
        }

        It 'Should return proper Type' {
            $result = Test-ServiceHealth -ServiceName $RunningService.Name
            $result.Type | Should -Be 'Service'
        }

        It 'Should include service name in Name property' {
            $result = Test-ServiceHealth -ServiceName $RunningService.Name
            $result.Name | Should -Be $RunningService.Name
        }

        It 'Should include ComputerName' {
            $result = Test-ServiceHealth -ServiceName $RunningService.Name
            $result.ComputerName | Should -Be $env:COMPUTERNAME
        }
    }

    Context 'When service exists but is stopped' {
        BeforeAll {
            # Find a stopped service
            $StoppedService = Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Select-Object -First 1
        }

        It 'Should return Status "ERROR" for stopped service' {
            if ($StoppedService) {
                $result = Test-ServiceHealth -ServiceName $StoppedService.Name
                $result.Status | Should -Be 'ERROR'
            }
        }

        It 'Should include service status in Comment' {
            if ($StoppedService) {
                $result = Test-ServiceHealth -ServiceName $StoppedService.Name
                $result.Comment | Should -Match 'Stopped'
            }
        }
    }

    Context 'When service does not exist' {
        It 'Should return Status "ERROR"' {
            $result = Test-ServiceHealth -ServiceName 'NonExistentService12345'
            $result.Status | Should -Be 'ERROR'
        }

        It 'Should have error comment' {
            $result = Test-ServiceHealth -ServiceName 'NonExistentService12345'
            $result.Comment | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'Test-URIHealth' {
    Context 'When URI is accessible' {
        It 'Should return Status "OK" for successful HTTP 200 response' {
            # Using a reliable public endpoint
            $result = Test-URIHealth -URI 'https://www.google.com' -UseBasicParsing $true -UseDefaultCredentials $false
            $result.Status | Should -Be 'OK'
        }

        It 'Should return proper Type' {
            $result = Test-URIHealth -URI 'https://www.google.com' -UseBasicParsing $true -UseDefaultCredentials $false
            $result.Type | Should -Be 'URI'
        }

        It 'Should include URI in Name property' {
            $result = Test-URIHealth -URI 'https://www.google.com' -UseBasicParsing $true -UseDefaultCredentials $false
            $result.Name | Should -Be 'https://www.google.com'
        }

        It 'Should include ComputerName' {
            $result = Test-URIHealth -URI 'https://www.google.com' -UseBasicParsing $true -UseDefaultCredentials $false
            $result.ComputerName | Should -Be $env:COMPUTERNAME
        }
    }

    Context 'When URI is not accessible' {
        It 'Should return Status "ERROR" for unreachable URI' {
            $result = Test-URIHealth -URI 'http://this-domain-should-not-exist-12345.com' -UseBasicParsing $true -UseDefaultCredentials $false
            $result.Status | Should -Be 'ERROR'
        }

        It 'Should have error comment' {
            $result = Test-URIHealth -URI 'http://this-domain-should-not-exist-12345.com' -UseBasicParsing $true -UseDefaultCredentials $false
            $result.Comment | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'Test-ScheduledTask' {
    Context 'When task exists' {
        BeforeAll {
            # Find a Windows scheduled task that exists
            $Task = Get-ScheduledTask | Where-Object { $_.TaskPath -and $_.TaskName } | Select-Object -First 1
            if ($Task) {
                $TaskPath = Join-Path $Task.TaskPath $Task.TaskName
            }
        }

        It 'Should not throw error for existing task' {
            if ($Task) {
                { Test-ScheduledTask -TaskPath $TaskPath } | Should -Not -Throw
            }
        }

        It 'Should return proper Type' {
            if ($Task) {
                $result = Test-ScheduledTask -TaskPath $TaskPath
                $result.Type | Should -Be 'ScheduledTask'
            }
        }

        It 'Should include task path in Name property' {
            if ($Task) {
                $result = Test-ScheduledTask -TaskPath $TaskPath
                $result.Name | Should -Be $TaskPath
            }
        }

        It 'Should have a Status property' {
            if ($Task) {
                $result = Test-ScheduledTask -TaskPath $TaskPath
                $result.Status | Should -Not -BeNullOrEmpty
            }
        }
    }

    Context 'When task does not exist' {
        It 'Should return Status "ERROR"' {
            $result = Test-ScheduledTask -TaskPath '\NonExistent\FakeTask'
            $result.Status | Should -Be 'ERROR'
        }

        It 'Should have error comment about task not found' {
            $result = Test-ScheduledTask -TaskPath '\NonExistent\FakeTask'
            $result.Comment | Should -Match 'not found'
        }
    }
}

Describe 'Get-FileCount' {
    Context 'When folder exists with files' {
        It 'Should return correct file count' {
            $result = Get-FileCount -FilePath $TestFolder
            $result.Status | Should -Be 5
        }

        It 'Should return proper Type' {
            $result = Get-FileCount -FilePath $TestFolder
            $result.Type | Should -Be 'FileCount'
        }

        It 'Should include folder name in Name property' {
            $result = Get-FileCount -FilePath $TestFolder
            $result.Name | Should -Be 'testfolder'
        }

        It 'Should include path in Comment' {
            $result = Get-FileCount -FilePath $TestFolder
            $result.Comment | Should -Be $TestFolder
        }

        It 'Should include ComputerName' {
            $result = Get-FileCount -FilePath $TestFolder
            $result.ComputerName | Should -Be $env:COMPUTERNAME
        }
    }

    Context 'When folder is empty' {
        BeforeAll {
            $EmptyFolder = Join-Path $TestDrive 'emptyfolder'
            New-Item -Path $EmptyFolder -ItemType Directory -Force | Out-Null
        }

        It 'Should return count of 0' {
            $result = Get-FileCount -FilePath $EmptyFolder
            $result.Status | Should -Be 0
        }
    }

    Context 'When folder does not exist' {
        It 'Should return Status "ERROR"' {
            $result = Get-FileCount -FilePath 'C:\NonExistentFolder12345'
            $result.Status | Should -Be 'ERROR'
        }

        It 'Should have error comment' {
            $result = Get-FileCount -FilePath 'C:\NonExistentFolder12345'
            $result.Comment | Should -Match 'not found'
        }
    }

    Context 'AppendLeaf functionality' {
        BeforeAll {
            $DateFolder = Join-Path $TestDrive 'datefolder'
            New-Item -Path $DateFolder -ItemType Directory -Force | Out-Null
            
            $TodayPath = Join-Path $DateFolder (Get-Date -Format 'yyyyMMdd')
            New-Item -Path $TodayPath -ItemType Directory -Force | Out-Null
            1..3 | ForEach-Object { New-Item -Path (Join-Path $TodayPath "file$_.txt") -ItemType File -Force | Out-Null }
            
            $YesterdayPath = Join-Path $DateFolder (Get-Date -Date ((Get-Date).AddDays(-1)) -Format 'yyyyMMdd')
            New-Item -Path $YesterdayPath -ItemType Directory -Force | Out-Null
            1..2 | ForEach-Object { New-Item -Path (Join-Path $YesterdayPath "file$_.txt") -ItemType File -Force | Out-Null }
        }

        It 'Should count files in today subfolder when AppendLeaf is Today' {
            $result = Get-FileCount -FilePath $DateFolder -AppendLeaf 'Today' -LeafFormat 'yyyyMMdd'
            $result.Status | Should -Be 3
        }

        It 'Should count files in yesterday subfolder when AppendLeaf is Yesterday' {
            $result = Get-FileCount -FilePath $DateFolder -AppendLeaf 'Yesterday' -LeafFormat 'yyyyMMdd'
            $result.Status | Should -Be 2
        }

        It 'Should include date in Name when using AppendLeaf' {
            $result = Get-FileCount -FilePath $DateFolder -AppendLeaf 'Today' -LeafFormat 'yyyyMMdd'
            $result.Name | Should -Match '\\'
        }
    }
}

Describe 'Test-ShareExists' {
    Context 'When testing local path as share' {
        It 'Should return Status "Exists" for accessible path' {
            # Test with system drive which should exist
            $systemDrive = $env:SystemDrive
            if (Test-Path $systemDrive) {
                $result = Test-ShareExists -SharePath $systemDrive
                $result.Status | Should -Be 'Exists'
            }
        }

        It 'Should return proper Type' {
            $systemDrive = $env:SystemDrive
            $result = Test-ShareExists -SharePath $systemDrive
            $result.Type | Should -Be 'ShareExists'
        }

        It 'Should include share name in Name property' {
            $systemDrive = $env:SystemDrive
            $result = Test-ShareExists -SharePath $systemDrive
            $result.Name | Should -Not -BeNullOrEmpty
        }

        It 'Should include ComputerName' {
            $systemDrive = $env:SystemDrive
            $result = Test-ShareExists -SharePath $systemDrive
            $result.ComputerName | Should -Be $env:COMPUTERNAME
        }
    }

    Context 'When share does not exist' {
        It 'Should return Status "Not Found"' {
            $result = Test-ShareExists -SharePath '\\NonExistentServer\Share'
            $result.Status | Should -Be 'Not Found'
        }
    }
}

Describe 'Get-Win32Error' -Skip {
    Context 'When looking up error codes' {
        It 'Should accept error code parameter' {
            { Get-Win32Error -ErrorCode 0 } | Should -Not -Throw
        }

        It 'Should return output for valid error code' {
            $result = Get-Win32Error -ErrorCode 0
            $result | Should -Not -BeNullOrEmpty
        }

        It 'Should handle decimal error codes' {
            { Get-Win32Error -ErrorCode 5 } | Should -Not -Throw
        }
    }
}

Describe 'Test-TimeSync' {
    Context 'Function signature and parameters' {
        It 'Should accept System1Name parameter' {
            { Get-Command Test-TimeSync -ErrorAction Stop } | Should -Not -Throw
            $params = (Get-Command Test-TimeSync).Parameters
            $params.ContainsKey('System1Name') | Should -Be $true
        }

        It 'Should accept System2Name parameter' {
            $params = (Get-Command Test-TimeSync).Parameters
            $params.ContainsKey('System2Name') | Should -Be $true
        }

        It 'Should return proper Type' {
            # This will fail connection but we can test the structure
            $result = Test-TimeSync -System1Name 'NonExistent1' -System2Name 'NonExistent2' -ErrorAction SilentlyContinue
            if ($result) {
                $result.Type | Should -Be 'TimeSync'
            }
        }
    }
}

Describe 'Integration Tests' {
    Context 'Real system checks' {
        It 'Should check multiple file existence scenarios' {
            $results = @(
                Test-FileExists -FilePath $TestFile -SystemName 'Integration Test'
                Test-FileExists -FilePath 'C:\NonExistent.txt' -SystemName 'Integration Test'
            )
            $results.Count | Should -Be 2
            $results[0].Status | Should -Be 'Exists'
            $results[1].Status | Should -Be 'Not Found'
        }

        It 'Should check multiple services' {
            $services = Get-Service | Select-Object -First 2
            $results = @()
            foreach ($svc in $services) {
                $results += Test-ServiceHealth -ServiceName $svc.Name -SystemName 'Integration Test'
            }
            $results.Count | Should -Be 2
            $results | ForEach-Object { $_.SystemName | Should -Be 'Integration Test' }
        }

        It 'All functions should return consistent object structure with required properties' {
            $requiredProperties = @('Type', 'Status', 'LastUpdate', 'ComputerName')
            
            $testResults = @(
                Test-FileExists -FilePath $TestFile
                Test-ProcessHealth -ProcessName (Get-Process -Id $PID).Name
                Get-FileCount -FilePath $TestFolder
            )

            foreach ($result in $testResults) {
                foreach ($prop in $requiredProperties) {
                    $result.PSObject.Properties.Name | Should -Contain $prop
                }
            }
        }
    }
}
