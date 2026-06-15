package com.mycompany.dentalclinicmanagementsystem.model;

import java.sql.Date;
import java.sql.Time;

public class EmployeeSchedule {
    private int scheduleId;
    private int userId;
    private Date workDate;
    private String shift;
    private Time startTime;
    private Time endTime;
    private int maxPatients;
    private boolean isDayOff;
    
    // Additional properties for UI
    private String employeeName;
    private String roleName;

    public EmployeeSchedule() {
    }

    public EmployeeSchedule(int scheduleId, int userId, Date workDate, String shift, Time startTime, Time endTime, int maxPatients, boolean isDayOff) {
        this.scheduleId = scheduleId;
        this.userId = userId;
        this.workDate = workDate;
        this.shift = shift;
        this.startTime = startTime;
        this.endTime = endTime;
        this.maxPatients = maxPatients;
        this.isDayOff = isDayOff;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getWorkDate() {
        return workDate;
    }

    public void setWorkDate(Date workDate) {
        this.workDate = workDate;
    }

    public String getShift() {
        return shift;
    }

    public void setShift(String shift) {
        this.shift = shift;
    }

    public Time getStartTime() {
        return startTime;
    }

    public void setStartTime(Time startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    public int getMaxPatients() {
        return maxPatients;
    }

    public void setMaxPatients(int maxPatients) {
        this.maxPatients = maxPatients;
    }

    public boolean isDayOff() {
        return isDayOff;
    }

    public void setDayOff(boolean isDayOff) {
        this.isDayOff = isDayOff;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
}
