CREATE TABLE [dbo].[BudgetYear_Admit_Note_Xref] (
    [BUDGETYEAR_ADMIT_NOTE_XREF_ID] INT IDENTITY (1, 1) NOT NULL,
    [PDTS_PROVIDER_ID]              INT NOT NULL,
    [NOTE_ID]                       INT NOT NULL,
    [BUDGETYEAR_ADMIT_ID]           INT NOT NULL,
    CONSTRAINT [PK_BudgetYear_Admit_Note_Xref] PRIMARY KEY CLUSTERED ([BUDGETYEAR_ADMIT_NOTE_XREF_ID] ASC),
    CONSTRAINT [FK_BudgetYear_Admit_Note_Xref_BudgetYear_Admit] FOREIGN KEY ([BUDGETYEAR_ADMIT_ID]) REFERENCES [dbo].[BudgetYear_Admit] ([BUDGETYEAR_ADMIT_ID]),
    CONSTRAINT [FK_BudgetYear_Admit_Note_Xref_Note] FOREIGN KEY ([NOTE_ID]) REFERENCES [dbo].[Note] ([NOTE_ID]),
    CONSTRAINT [FK_BudgetYear_Admit_Note_Xref_Provider] FOREIGN KEY ([PDTS_PROVIDER_ID]) REFERENCES [dbo].[Provider] ([PDTS_PROVIDER_ID]) ON DELETE CASCADE
);

