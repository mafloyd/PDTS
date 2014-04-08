CREATE TABLE [dbo].[SourceToTargetFieldMapping] (
    [SOURCE_TO_TARGET_FIELD_MAPPING_ID] INT          IDENTITY (1, 1) NOT NULL,
    [EXTRACT_ID]                        INT          NOT NULL,
    [SOURCE_FIELD_NAME]                 VARCHAR (50) NOT NULL,
    [SOURCE_BEGIN_COLUMN]               INT          CONSTRAINT [DF_SourceToTargetFieldMapping_SOURCE_BEGIN_COLUMN] DEFAULT ((0)) NOT NULL,
    [SOURCE_END_COLUMN]                 INT          CONSTRAINT [DF_SourceToTargetFieldMapping_SOURCE_END_COLUMN] DEFAULT ((0)) NOT NULL,
    [TARGET_FIELD_NAME]                 VARCHAR (50) NULL,
    [IS_AMOUNT_COLUMN_TO_IMPORT]        BIT          CONSTRAINT [DF_SourceToTargetFieldMapping_IS_AMOUNT_COLUMN_TO_IMPORT] DEFAULT ((0)) NOT NULL,
    [SOURCE_FIELD_TYPE]                 VARCHAR (10) NOT NULL,
    [DELIMITER]                         CHAR (1)     NULL,
    [DELIMITED_COLUMN]                  SMALLINT     CONSTRAINT [DF_SourceToTargetFieldMapping_DELMITED_COLUMN] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SOURCE_TO_TARGET_FIELD_MAPPING] PRIMARY KEY CLUSTERED ([SOURCE_TO_TARGET_FIELD_MAPPING_ID] ASC),
    CONSTRAINT [FK_SourceToTargetFieldMapping_Extract] FOREIGN KEY ([EXTRACT_ID]) REFERENCES [dbo].[Extract] ([EXTRACT_ID])
);

