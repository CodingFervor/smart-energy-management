package model

import "time"

type User struct {
	ID        int64     `json:"id" db:"id"`
	Username  string    `json:"username" db:"username"`
	Password  string    `json:"-" db:"password"`
	Name      string    `json:"name" db:"name"`
	Role      string    `json:"role" db:"role"`
	Status    string    `json:"status" db:"status"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
}

type Building struct {
	ID         int64     `json:"id" db:"id"`
	Name       string    `json:"name" db:"name"`
	Code       string    `json:"code" db:"code"`
	Address    string    `json:"address" db:"address"`
	Floors     int       `json:"floors" db:"floors"`
	Area       float64   `json:"area" db:"area"` // sq meters
	Type       string    `json:"type" db:"type"` // office, residential, factory, commercial
	Status     string    `json:"status" db:"status"`
	CreatedAt  time.Time `json:"created_at" db:"created_at"`
}

type Zone struct {
	ID          int64   `json:"id" db:"id"`
	BuildingID  int64   `json:"building_id" db:"building_id"`
	Name        string  `json:"name" db:"name"`
	Floor       int     `json:"floor" db:"floor"`
	Area        float64 `json:"area" db:"area"`
	EnergyType  string  `json:"energy_type" db:"energy_type"` // electricity, gas, water
}

type Meter struct {
	ID          int64     `json:"id" db:"id"`
	Code        string    `json:"code" db:"code"`
	BuildingID  int64     `json:"building_id" db:"building_id"`
	ZoneID      *int64    `json:"zone_id" db:"zone_id"`
	Type        string    `json:"type" db:"type"` // electricity, gas, water
	DeviceID    string    `json:"device_id" db:"device_id"`
	Status      string    `json:"status" db:"status"` // active, inactive, fault
	InstallDate time.Time `json:"install_date" db:"install_date"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}

type MeterReading struct {
	ID         int64     `json:"id" db:"id"`
	MeterID    int64     `json:"meter_id" db:"meter_id"`
	Value      float64   `json:"value" db:"value"`
	Unit       string    `json:"unit" db:"unit"` // kWh, m3
	RecordedAt time.Time `json:"recorded_at" db:"recorded_at"`
}

type Bill struct {
	ID          int64     `json:"id" db:"id"`
	BuildingID  int64     `json:"building_id" db:"building_id"`
	MeterID     int64     `json:"meter_id" db:"meter_id"`
	PeriodStart time.Time `json:"period_start" db:"period_start"`
	PeriodEnd   time.Time `json:"period_end" db:"period_end"`
	Usage       float64   `json:"usage" db:"usage"`
	Amount      float64   `json:"amount" db:"amount"`
	Status      string    `json:"status" db:"status"` // unpaid, paid, overdue
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}

type Tariff struct {
	ID        int64     `json:"id" db:"id"`
	Name      string    `json:"name" db:"name"`
	Type      string    `json:"type" db:"type"`
	Rate      float64   `json:"rate" db:"rate"`     // price per unit
	PeakRate  float64   `json:"peak_rate" db:"peak_rate"`
	OffPeakRate float64 `json:"off_peak_rate" db:"off_peak_rate"`
	StartTime string    `json:"start_time" db:"start_time"`
	EndTime   string    `json:"end_time" db:"end_time"`
	Enabled   bool      `json:"enabled" db:"enabled"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
}

type Alert struct {
	ID         int64     `json:"id" db:"id"`
	BuildingID int64     `json:"building_id" db:"building_id"`
	MeterID    *int64    `json:"meter_id" db:"meter_id"`
	Type       string    `json:"type" db:"type"` // overuse, anomaly, fault, threshold
	Severity   string    `json:"severity" db:"severity"` // info, warning, critical
	Message    string    `json:"message" db:"message"`
	Acknowledged bool   `json:"acknowledged" db:"acknowledged"`
	CreatedAt  time.Time `json:"created_at" db:"created_at"`
}

type AlertRule struct {
	ID         int64     `json:"id" db:"id"`
	BuildingID *int64    `json:"building_id" db:"building_id"`
	MeterID    *int64    `json:"meter_id" db:"meter_id"`
	Metric     string    `json:"metric" db:"metric"`
	Condition  string    `json:"condition" db:"condition"` // greater_than, less_than
	Threshold  float64   `json:"threshold" db:"threshold"`
	Severity   string    `json:"severity" db:"severity"`
	Enabled    bool      `json:"enabled" db:"enabled"`
	CreatedAt  time.Time `json:"created_at" db:"created_at"`
}

type RenewableSource struct {
	ID          int64     `json:"id" db:"id"`
	BuildingID  int64     `json:"building_id" db:"building_id"`
	Type        string    `json:"type" db:"type"` // solar, wind
	Capacity    float64   `json:"capacity" db:"capacity"` // kW
	CurrentOutput float64 `json:"current_output" db:"current_output"`
	TotalGenerated float64 `json:"total_generated" db:"total_generated"` // kWh
	Status      string    `json:"status" db:"status"`
	InstalledAt time.Time `json:"installed_at" db:"installed_at"`
}

type CarbonRecord struct {
	ID          int64     `json:"id" db:"id"`
	BuildingID  int64     `json:"building_id" db:"building_id"`
	Date        time.Time `json:"date" db:"date"`
	ElectricityKWh float64 `json:"electricity_kwh" db:"electricity_kwh"`
	GasM3       float64   `json:"gas_m3" db:"gas_m3"`
	CarbonKg    float64   `json:"carbon_kg" db:"carbon_kg"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}
