﻿/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

/*Example script*/
--:r .\CPT_HCPCS.ReferenceData.sql
--:r .\CTPCategory.ReferenceData.sql
:r .\dbo.Facility.data.sql
:r .\dbo.Modules.data.sql