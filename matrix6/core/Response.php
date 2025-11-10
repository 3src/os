<?php
/**
 * Response Helper
 * Handles JSON and text responses
 */

class Response {
    /**
     * Send JSON response
     */
    public static function json($data, $statusCode = 200) {
        http_response_code($statusCode);
        header('Content-Type: application/json');
        echo json_encode($data);
        exit;
    }

    /**
     * Send text response
     */
    public static function text($message, $statusCode = 200) {
        http_response_code($statusCode);
        header('Content-Type: text/plain');
        echo $message;
        exit;
    }

    /**
     * Send HTML response
     */
    public static function html($html, $statusCode = 200) {
        http_response_code($statusCode);
        header('Content-Type: text/html');
        echo $html;
        exit;
    }

    /**
     * Send error response
     */
    public static function error($message, $statusCode = 400) {
        self::json(['error' => $message, 'success' => false], $statusCode);
    }

    /**
     * Send success response
     */
    public static function success($message, $data = []) {
        self::json(array_merge(['success' => true, 'message' => $message], $data));
    }

    /**
     * Redirect to URL
     */
    public static function redirect($url, $statusCode = 302) {
        http_response_code($statusCode);
        header("Location: $url");
        exit;
    }
}
