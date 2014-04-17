CREATE TABLE [dbo].[OP_IMAGING] (
    [coid]                    VARCHAR (5) NULL,
    [Patient_Account]         CHAR (20)   NULL,
    [cod_dtl_ds]              CHAR (40)   NOT NULL,
    [order_type_desc]         CHAR (40)   NULL,
    [order_code_desc1]        CHAR (80)   NULL,
    [Arrive_Time]             DATETIME    NULL,
    [Reg_Start_Time]          DATETIME    NULL,
    [Reg_Completion_Time]     DATETIME    NOT NULL,
    [Exam_Start_Time]         DATETIME    NULL,
    [Exam_Completion_Time]    DATETIME    NULL,
    [Prelim_Report_Available] DATETIME    NULL,
    [Discharge_Time]          DATETIME    NULL
);

