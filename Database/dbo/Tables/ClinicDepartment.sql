CREATE TABLE [dbo].[ClinicDepartment] (
    [CLINIC_DEPT_ID]     INT          NOT NULL,
    [DEPT_NUMBER]        INT          NOT NULL,
    [NAME]               VARCHAR (50) NOT NULL,
    [CREATE_DATE]        DATETIME     NOT NULL,
    [CREATED_BY_USER_ID] INT          NOT NULL,
    [UPDATE_DATE]        DATETIME     NULL,
    [UPDATED_BY_USER_ID] INT          NULL,
    CONSTRAINT [PK_ClinicDepartment] PRIMARY KEY CLUSTERED ([CLINIC_DEPT_ID] ASC)
);

