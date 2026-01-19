-- Postgres Migration for HelpingHive

-- Users Table
-- Replaced AUTO_INCREMENT with SERIAL
-- Replaced ENUM with VARCHAR + CHECK constraints (more portable) or native TYPES
-- Adjusted TIMESTAMP defaults

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('volunteer', 'organization')),
    location VARCHAR(255),
    contact_number VARCHAR(20),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Skills Master Table
CREATE TABLE Skills (
    skill_id SERIAL PRIMARY KEY,
    skill_name VARCHAR(100) UNIQUE NOT NULL,
    skill_category VARCHAR(100)
);

-- Volunteer Skills Mapping
CREATE TABLE Volunteer_Skills (
    volunteer_skill_id SERIAL PRIMARY KEY,
    user_id INT,
    skill_id INT,
    proficiency_level VARCHAR(20) DEFAULT 'beginner' CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skills(skill_id) ON DELETE CASCADE,
    UNIQUE (user_id, skill_id)
);

-- Organizations Profile Table
CREATE TABLE Organizations (
    organization_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE,
    organization_name VARCHAR(255) NOT NULL,
    description TEXT,
    website_url VARCHAR(255),
    contact_person VARCHAR(100),
    verification_status VARCHAR(20) DEFAULT 'pending' CHECK (verification_status IN ('pending', 'verified', 'rejected')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Volunteer Availability
CREATE TABLE Volunteer_Availability (
    availability_id SERIAL PRIMARY KEY,
    user_id INT,
    day_of_week VARCHAR(20) CHECK (day_of_week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')),
    start_time TIME,
    end_time TIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Volunteer Opportunities
CREATE TABLE Volunteer_Opportunities (
    opportunity_id SERIAL PRIMARY KEY,
    organization_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255),
    start_date DATE,
    end_date DATE,
    required_skills_count INT DEFAULT 1,
    max_volunteers INT,
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'closed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES Organizations(organization_id) ON DELETE CASCADE
);

-- Required Skills for Opportunities
CREATE TABLE Opportunity_Required_Skills (
    opportunity_skill_id SERIAL PRIMARY KEY,
    opportunity_id INT,
    skill_id INT,
    required_proficiency VARCHAR(20) CHECK (required_proficiency IN ('beginner', 'intermediate', 'advanced')),
    FOREIGN KEY (opportunity_id) REFERENCES Volunteer_Opportunities(opportunity_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skills(skill_id) ON DELETE CASCADE
);

-- Volunteer Applications
CREATE TABLE Volunteer_Applications (
    application_id SERIAL PRIMARY KEY,
    user_id INT,
    opportunity_id INT,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
    motivation_letter TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (opportunity_id) REFERENCES Volunteer_Opportunities(opportunity_id) ON DELETE CASCADE,
    UNIQUE (user_id, opportunity_id)
);

-- Feedback and Reviews
CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    reviewer_id INT,
    reviewee_id INT,
    opportunity_id INT,
    rating DECIMAL(3,2) CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    review_type VARCHAR(30) CHECK (review_type IN ('volunteer_to_org', 'org_to_volunteer')),
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reviewer_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewee_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (opportunity_id) REFERENCES Volunteer_Opportunities(opportunity_id) ON DELETE CASCADE
);

-- Notifications Table
CREATE TABLE Notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT,
    content TEXT NOT NULL,
    type VARCHAR(30) NOT NULL CHECK (type IN ('match', 'application_status', 'opportunity', 'review')),
    related_entity_id INT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_user_email ON Users(email);
CREATE INDEX idx_opportunity_status ON Volunteer_Opportunities(status);
CREATE INDEX idx_application_status ON Volunteer_Applications(status);
