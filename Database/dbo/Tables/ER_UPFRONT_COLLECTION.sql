CREATE TABLE [dbo].[ER_UPFRONT_COLLECTION] (
    [ER_UPFRONT_COLLECTION_ID] INT            IDENTITY (1, 1) NOT NULL,
    [COID]                     VARCHAR (5)    NOT NULL,
    [MONTH]                    INT            NOT NULL,
    [YEAR]                     INT            NOT NULL,
    [AMOUNT]                   MONEY          NOT NULL,
    [PERCENTAGE]               DECIMAL (5, 2) NOT NULL,
    CONSTRAINT [PK_ER_UPFRONT_COLLECTION] PRIMARY KEY CLUSTERED ([ER_UPFRONT_COLLECTION_ID] ASC),
    CONSTRAINT [FK_ER_UPFRONT_COLLECTION_Facility] FOREIGN KEY ([COID]) REFERENCES [dbo].[Facility] ([COID])
);

