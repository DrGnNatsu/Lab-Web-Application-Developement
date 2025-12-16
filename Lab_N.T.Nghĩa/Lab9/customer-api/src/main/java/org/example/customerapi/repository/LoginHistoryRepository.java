package org.example.customerapi.repository;

import org.example.customerapi.entity.LoginHistory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LoginHistoryRepository extends JpaRepository<LoginHistory, Long> {
    List<LoginHistory> findByUser_IdOrderByLoginTimeDesc(Long userId);
}
