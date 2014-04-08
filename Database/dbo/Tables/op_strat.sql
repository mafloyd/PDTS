CREATE TABLE [dbo].[op_strat] (
    [coid]                     NVARCHAR (5)   NULL,
    [hospital_name]            NVARCHAR (255) NULL,
    [group_name]               NVARCHAR (255) NULL,
    [strategy]                 NVARCHAR (255) NULL,
    [tactic]                   NVARCHAR (255) NULL,
    [project_owner]            NVARCHAR (255) NULL,
    [complete_date]            NVARCHAR (255) NULL,
    [measuruable_results]      NVARCHAR (255) NULL,
    [targeted_completion_date] DATETIME       NULL
);

