$env:GIT_REDIRECT_STDERR = '2>&1'
$projectsDirectory = Join-Path $home "projects"
if (![System.IO.Directory]::Exists($projectsDirectory)) { [System.IO.Directory]::CreateDirectory($projectsDirectory) }

$token = "token 41236be111df32b2fb32172aeeb5608d9bdc16dd";
$repoList = (Invoke-WebRequest -Uri https://api.github.com/user/repos -Headers @{"Authorization"=$token} -UseBasicParsing).Content | ConvertFrom-Json | % {$_.clone_url};

Push-Location $projectsDirectory;
Write-Output "Downloading all repos to " $projectsDirectory;

foreach($repo in $repoList) {
    Write-Output "Downloading: " $repo;
    git clone $repo;
}