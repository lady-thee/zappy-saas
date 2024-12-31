-- Create a ENUM table for file_type
CREATE TYPE file_type_enum AS ENUM (
    'audio',
    'video'
);

-- Create a ENUM table for file_status
CREATE TYPE file_status_enum AS ENUM (
    'pending',
    'processed',
    'archived',
    'deleted'
);

-- Create a FILES table 
CREATE TABLE files (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID  NULL,
    file_path    VARCHAR(100) NOT NULL,
    file_name    VARCHAR(50) NOT NULL,
    file_type    file_type_enum,
    file_status  file_status_enum DEFAULT 'pending',
    file_size     BIGINT,
    file_duration INTERVAL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP NULL
);


-- Create TRANSCRIPTION table
CREATE TABLE transcription (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    file_id           UUID NOT NULL REFERENCES files (id) ON DELETE CASCADE,
    transcribed_text  TEXT NOT NULL, 
    text_language     VARCHAR(50) NULL, 
    confidence_score   DECIMAL(5, 2),
    errors             INTEGER,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP NULL
);

CREATE INDEX idx_file_id on transcription(file_id);