# Script name:   	check_ms_sharepoint_2010_connections.ps1
# Version:			v1.00.151116
# Created on:    	16/11/2015
# Author:        	Riebbels Willem
#					http://geekswithblogs.net/Lance/archive/2009/06/03/get-the-number-of-current-sharepoint-connections.aspx
# Purpose:       	Checks Microsoft SharePoint Connections per Web App. The plugin is still in testing phase.
#					Tested on two different SharePoint farms and seems to work ok.
# On Github:		https://github.com/2Dman/check-ms-sharepoint-connections/
# On Oper-Init.eu
# Recent History:       	
#	16/11/15 => First edit
# Copyright:
#	This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published
#	by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed 
#	in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
#	PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public 
#	License along with this program.  If not, see <http://www.gnu.org/licenses/>.

function Get-WebServiceConnections()
{
try{
  $perfmon = new-object System.Diagnostics.PerformanceCounter
  $perfmon.CategoryName = "Web Service"
  $perfmon.CounterName = "Current Connections"

  $cat = new-object System.Diagnostics.PerformanceCounterCategory("Web Service")
  $instances = $cat.GetInstanceNames()

  $results = @() 
  foreach ($instance in $instances)
  {
  	$perfmon.InstanceName = $instance
  
	$result = New-Object -TypeName PSCustomObject -Property @{

	'WebApp' = $WebApp = $instance
	'Connections' = $Connections = $perfmon.NextValue()
	}
	$results += $result
  }
  $output = @()


  
  
  foreach($obj in $results)
  {
  #CleanUpInNamingConventions
  $CleanObjWebAppName =  $(((($obj.WebApp).replace("SharePoint","")).replace("-","")).replace("_",""))
  $output += "'$CleanObjWebAppName'=$($obj.Connections)" 
  }
  
  Write-host "Aantal Connecties naar de sharepoint web apps: | $Output"
  exit 0
  }
 catch
 {
  Write-host "Something Happened"
 exit 2
 }
 }
Get-WebServiceConnections
