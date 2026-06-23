package com.mycompany.dentalclinicmanagementsystem.model;

import java.math.BigDecimal;
import java.sql.Date;

public class TreatmentStep {
    private Integer stepId;
    private Integer planId;
    private Integer stepOrder;
    private String description;
    private BigDecimal estimatedCost;
    private Date nextAppointmentDate;
    private String status;

    public TreatmentStep() {
    }

    public Integer getStepId() {
        return stepId;
    }

    public void setStepId(Integer stepId) {
        this.stepId = stepId;
    }

    public Integer getPlanId() {
        return planId;
    }

    public void setPlanId(Integer planId) {
        this.planId = planId;
    }

    public Integer getStepOrder() {
        return stepOrder;
    }

    public void setStepOrder(Integer stepOrder) {
        this.stepOrder = stepOrder;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getEstimatedCost() {
        return estimatedCost;
    }

    public void setEstimatedCost(BigDecimal estimatedCost) {
        this.estimatedCost = estimatedCost;
    }

    public Date getNextAppointmentDate() {
        return nextAppointmentDate;
    }

    public void setNextAppointmentDate(Date nextAppointmentDate) {
        this.nextAppointmentDate = nextAppointmentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
