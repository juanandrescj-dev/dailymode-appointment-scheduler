CREATE DATABASE appointment_scheduler_db;
GO
USE appointment_scheduler_db;
GO

-- #############################################################################
-- ########################### CREATION OF THE TABLES ##############################
-- #############################################################################

-- TABLE: countries
-- Defines the countries to which users, provinces, and businesses belong.
CREATE TABLE countries (
    country_id UUID PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
	status_id INT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ NULL,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE countries ADD CONSTRAINT fk_countries_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE countries ADD CONSTRAINT fk_countries_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: countries
-- Defines the countries to which users, provinces, and businesses belong.
CREATE TABLE provinces (
    province_id UUID PRIMARY KEY,
    province_name VARCHAR(100) NOT NULL,
	status_id INT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ NULL,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE provinces ADD CONSTRAINT fk_provinces_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE provinces ADD CONSTRAINT fk_provinces_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: users
-- Stores information about system users (customers, employees, administrators) who interact with businesses.
CREATE TABLE users (
    user_id UUID PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    id_card VARCHAR(50) UNIQUE NOT NULL,
    country VARCHAR(100),
    province VARCHAR(100),
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255) UNIQUE NOT NULL,
    user_name VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- A hash of the password must be stored
    status_id INT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ NULL,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE users ADD CONSTRAINT fk_users_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE users ADD CONSTRAINT fk_users_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: statuses
-- Defines the different states that records can have (active, inactive, pending).
CREATE TABLE statuses (
    status_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ NULL,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE countries ADD CONSTRAINT fk_countries_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE provinces ADD CONSTRAINT fk_provinces_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE users ADD CONSTRAINT fk_users_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE statuses ADD CONSTRAINT fk_statuses_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE statuses ADD CONSTRAINT fk_statuses_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: roles
-- Defines user roles in a business (e.g., Administrator, Employee).
CREATE TABLE roles (
    role_id UUID PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
	status_id INT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ NULL,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE users ADD CONSTRAINT fk_roles_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE roles ADD CONSTRAINT fk_roles_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE roles ADD CONSTRAINT fk_roles_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: businesses
-- Stores business or company information.
CREATE TABLE businesses (
    business_id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    rnc VARCHAR(50) UNIQUE,
    country VARCHAR(100),
    province VARCHAR(100),
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    status_id INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ NULL,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE businesses ADD CONSTRAINT fk_businesses_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE businesses ADD CONSTRAINT fk_businesses_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE businesses ADD CONSTRAINT fk_businesses_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: users_roles_businesses 
-- Stores and defines the roles that each user has in a business.
CREATE TABLE users_roles (
    user_role_id UUID PRIMARY KEY,
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    status_id INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE users_roles ADD CONSTRAINT fk_usersroles_users_userid FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE users_roles ADD CONSTRAINT fk_usersroles_roles_roleid FOREIGN KEY (role_id) REFERENCES roles(role_id);
ALTER TABLE users_roles ADD CONSTRAINT fk_usersroles_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE users_roles ADD CONSTRAINT fk_usersroles_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE users_roles ADD CONSTRAINT fk_usersroles_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: services
-- Defines the services offered by businesses (for example, haircut, beard shave, dental consultation).
CREATE TABLE services (
    service_id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    duration_in_hours NUMERIC(5, 2) NOT NULL,
    business_id UUID NOT NULL,
    status_id INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE services ADD CONSTRAINT fk_services_businesses_businessid FOREIGN KEY (business_id) REFERENCES businesses(business_id);
ALTER TABLE services ADD CONSTRAINT fk_services_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE services ADD CONSTRAINT fk_services_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE services ADD CONSTRAINT fk_services_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: appointments
-- Stores information about scheduled appointments.
CREATE TABLE appointments (
    appointment_id UUID PRIMARY KEY,
    business_id BIGINT NOT NULL,
    client_id BIGINT NOT NULL,
    start_datetime TIMESTAMPTZ NOT NULL,
    end_datetime TIMESTAMPTZ NOT NULL,
    client_notes TEXT,
    internal_notes TEXT,
    status_id INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE appointments ADD CONSTRAINT fk_appointments_businesses_businessid FOREIGN KEY (business_id) REFERENCES businesses(business_id);
ALTER TABLE appointments ADD CONSTRAINT fk_appointments_users_clientid FOREIGN KEY (client_id) REFERENCES users(user_id);
ALTER TABLE appointments ADD CONSTRAINT fk_appointments_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE appointments ADD CONSTRAINT fk_appointments_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE appointments ADD CONSTRAINT fk_appointments_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: appointments_services
-- Join table to detail which services are included in an appointment.
CREATE TABLE appointments_services (
    appointments_services_id UUID PRIMARY KEY,
    appointment_id BIGINT NOT NULL,
    service_id INT NOT NULL,
    status_id INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE appointments_services ADD CONSTRAINT fk_appointmentsservices_appointments_appointmentid FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id);
ALTER TABLE appointments_services ADD CONSTRAINT fk_appointmentsservices_services_serviceid FOREIGN KEY (service_id) REFERENCES services(service_id);
ALTER TABLE appointments_services ADD CONSTRAINT fk_appointmentsservices_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE appointments_services ADD CONSTRAINT fk_appointmentsservices_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE appointments_services ADD CONSTRAINT fk_appointmentsservices_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: blocking_reasons
-- Reasons why a (professional) user's availability slot may be blocked.
CREATE TABLE blocking_reasons (
    blocking_reason_id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    start_datetime TIMESTAMPTZ,
    end_datetime TIMESTAMPTZ,
    status_id INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE blocking_reasons ADD CONSTRAINT fk_blockingreasons_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE blocking_reasons ADD CONSTRAINT fk_blockingreasons_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE blocking_reasons ADD CONSTRAINT fk_blockingreasons_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLE: availability
-- Defines standard staff availability schedules.
CREATE TABLE availability (
    availability_id UUID PRIMARY KEY,
    user_id BIGINT NOT NULL,
    day_of_the_week INT NOT NULL, -- ISO 8601: 1 = Monday, 7 = Sunday
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    validity_start_date DATE NOT NULL,
    validity_end_date DATE,
    status_id INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE availability ADD CONSTRAINT fk_availability_users_userid FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE availability ADD CONSTRAINT fk_availability_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE availability ADD CONSTRAINT fk_availability_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE availability ADD CONSTRAINT fk_availability_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);


-- TABLA: availability_blocks
-- Specific blocks on a user's availability.
CREATE TABLE availability_blocks (
    availability_block_id UUID PRIMARY KEY,
    user_id BIGINT NOT NULL,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    blocking_reason_id INT,
    status_id INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    modified_by BIGINT
);
ALTER TABLE availability_blocks ADD CONSTRAINT fk_availabilityblocks_users_userid FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE availability_blocks ADD CONSTRAINT fk_availabilityblocks_blockingreasons_blockingreasonid FOREIGN KEY (blocking_reason_id) REFERENCES blocking_reasons(blocking_reason_id);
ALTER TABLE availability_blocks ADD CONSTRAINT fk_availabilityblocks_statuses_statusid FOREIGN KEY (status_id) REFERENCES statuses(status_id);
ALTER TABLE availability_blocks ADD CONSTRAINT fk_availabilityblocks_users_createdby FOREIGN KEY (created_by) REFERENCES users(user_id);
ALTER TABLE availability_blocks ADD CONSTRAINT fk_availabilityblocks_users_modifiedby FOREIGN KEY (modified_by) REFERENCES users(user_id);