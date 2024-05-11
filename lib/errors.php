<?php

function json_error($status, $message) {
  header('Content-Type: application/json');
  http_response_code($status);

  echo json_encode(['error' => $message]);
  exit(1);
}
