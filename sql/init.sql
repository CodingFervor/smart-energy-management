CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY, username VARCHAR(50) UNIQUE NOT NULL, password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL, role VARCHAR(20) DEFAULT 'operator' CHECK (role IN ('admin','operator','viewer')),
    status VARCHAR(20) DEFAULT 'active', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE buildings (
    id BIGSERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL, code VARCHAR(20) UNIQUE NOT NULL,
    address TEXT, floors INT DEFAULT 1, area DECIMAL(12,2),
    type VARCHAR(20) DEFAULT 'office' CHECK (type IN ('office','residential','factory','commercial')),
    status VARCHAR(20) DEFAULT 'active', created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE zones (
    id BIGSERIAL PRIMARY KEY, building_id BIGINT NOT NULL REFERENCES buildings(id),
    name VARCHAR(50) NOT NULL, floor INT DEFAULT 1, area DECIMAL(10,2),
    energy_type VARCHAR(20) DEFAULT 'electricity' CHECK (energy_type IN ('electricity','gas','water'))
);

CREATE TABLE meters (
    id BIGSERIAL PRIMARY KEY, code VARCHAR(50) UNIQUE NOT NULL,
    building_id BIGINT NOT NULL REFERENCES buildings(id), zone_id BIGINT REFERENCES zones(id),
    type VARCHAR(20) NOT NULL CHECK (type IN ('electricity','gas','water')),
    device_id VARCHAR(100), status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active','inactive','fault')),
    install_date DATE DEFAULT CURRENT_DATE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE meter_readings (
    id BIGSERIAL PRIMARY KEY, meter_id BIGINT NOT NULL REFERENCES meters(id),
    value DECIMAL(12,4) NOT NULL, unit VARCHAR(10) DEFAULT 'kWh',
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_readings_meter ON meter_readings(meter_id);
CREATE INDEX idx_readings_time ON meter_readings(recorded_at);

CREATE TABLE tariffs (
    id BIGSERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('electricity','gas','water')),
    rate DECIMAL(10,4) NOT NULL, peak_rate DECIMAL(10,4), off_peak_rate DECIMAL(10,4),
    peak_start TIME DEFAULT '08:00', peak_end TIME DEFAULT '22:00',
    enabled BOOLEAN DEFAULT TRUE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bills (
    id BIGSERIAL PRIMARY KEY, building_id BIGINT NOT NULL REFERENCES buildings(id),
    meter_id BIGINT NOT NULL REFERENCES meters(id),
    period_start DATE NOT NULL, period_end DATE NOT NULL,
    usage DECIMAL(12,4) NOT NULL, amount DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'unpaid' CHECK (status IN ('unpaid','paid','overdue')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_bills_building ON bills(building_id);
CREATE INDEX idx_bills_status ON bills(status);

CREATE TABLE alerts (
    id BIGSERIAL PRIMARY KEY, building_id BIGINT NOT NULL REFERENCES buildings(id),
    meter_id BIGINT REFERENCES meters(id),
    type VARCHAR(20) NOT NULL CHECK (type IN ('overuse','anomaly','fault','threshold')),
    severity VARCHAR(10) DEFAULT 'warning' CHECK (severity IN ('info','warning','critical')),
    message TEXT, acknowledged BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE alert_rules (
    id BIGSERIAL PRIMARY KEY, building_id BIGINT REFERENCES buildings(id),
    meter_id BIGINT REFERENCES meters(id), metric VARCHAR(50) NOT NULL,
    condition VARCHAR(20) DEFAULT 'greater_than', threshold DECIMAL(12,4) NOT NULL,
    severity VARCHAR(10) DEFAULT 'warning', enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE renewable_sources (
    id BIGSERIAL PRIMARY KEY, building_id BIGINT NOT NULL REFERENCES buildings(id),
    type VARCHAR(20) NOT NULL CHECK (type IN ('solar','wind')),
    capacity_kw DECIMAL(10,2) NOT NULL, current_output DECIMAL(10,2) DEFAULT 0,
    total_generated_kwh DECIMAL(12,2) DEFAULT 0,
    status VARCHAR(20) DEFAULT 'active', installed_at DATE DEFAULT CURRENT_DATE
);

CREATE TABLE carbon_records (
    id BIGSERIAL PRIMARY KEY, building_id BIGINT NOT NULL REFERENCES buildings(id),
    date DATE NOT NULL, electricity_kwh DECIMAL(12,2), gas_m3 DECIMAL(10,2),
    carbon_kg DECIMAL(12,4), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX idx_carbon_date ON carbon_records(building_id, date);

INSERT INTO users (username, password, name, role) VALUES
('admin', '$2a$10$dummyhash', 'Admin', 'admin');

INSERT INTO tariffs (name, type, rate, peak_rate, off_peak_rate) VALUES
('Standard Electricity', 'electricity', 0.85, 1.20, 0.45),
('Standard Gas', 'gas', 3.50, 3.50, 3.50),
('Standard Water', 'water', 5.00, 5.00, 5.00);
