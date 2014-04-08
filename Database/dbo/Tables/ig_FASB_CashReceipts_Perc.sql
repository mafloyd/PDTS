CREATE TABLE [dbo].[ig_FASB_CashReceipts_Perc] (
    [RECEIPT_PERC_ID] INT            IDENTITY (1, 1) NOT NULL,
    [WORKSHEET_ID]    INT            NULL,
    [MONTH]           INT            NULL,
    [PROJECTED_PCT]   DECIMAL (9, 4) NULL,
    [CREATED_DATE]    DATETIME       NULL,
    [CREATED_BY]      INT            NULL,
    CONSTRAINT [PK_igFASBCashReceiptsPerc] PRIMARY KEY CLUSTERED ([RECEIPT_PERC_ID] ASC)
);

