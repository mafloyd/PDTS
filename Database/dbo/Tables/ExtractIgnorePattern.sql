CREATE TABLE [dbo].[ExtractIgnorePattern] (
    [EXTRACT_INGORE_PATTERN_ID] INT           IDENTITY (1, 1) NOT NULL,
    [EXTRACT_ID]                INT           NOT NULL,
    [IGNORE_PATTERN]            VARCHAR (250) NOT NULL,
    CONSTRAINT [PK_ExtractIgnorePattern] PRIMARY KEY CLUSTERED ([EXTRACT_INGORE_PATTERN_ID] ASC),
    CONSTRAINT [FK_ExtractIgnorePattern_Extract] FOREIGN KEY ([EXTRACT_ID]) REFERENCES [dbo].[Extract] ([EXTRACT_ID])
);

