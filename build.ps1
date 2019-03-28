#!/usr/bin/env pwsh

    [CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [String]$packageVersion
)

$currentPath = (Get-Location -PSProvider FileSystem).ProviderPath

if ($packageVersion[0] -eq 'v')
{
    $packageVersion = $packageVersion.Substring(1)
}

Set-Location Solution

dotnet restore

# `dotnet build` must run before `dotnet publish` because GeneratePackageOnBuild in csproj forces not to build when running `dotnet publish` command
# https://github.com/dotnet/core/issues/1778
dotnet build --no-restore -c Release "/property:Version=${packageVersion}"

dotnet publish --no-restore -c Release --no-build
