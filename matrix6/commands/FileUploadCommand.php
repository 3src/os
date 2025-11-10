<?php
/**
 * File Upload Command
 * Handles file uploads to the server
 */

class FileUploadCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'upload';
    }

    public function getDescription() {
        return 'Upload a file to the server';
    }

    public function execute($params = []) {
        // Check if file upload is enabled
        if (!$this->config['security']['file_upload']) {
            return "File upload is disabled for security reasons.";
        }

        // Check if file was uploaded
        if (empty($_FILES['file']['tmp_name'])) {
            return "No file was uploaded.";
        }

        // Check if path was provided
        if (empty($params['path'])) {
            return "No upload path specified.";
        }

        $filename = basename($_FILES['file']['name']);
        $path = rtrim($params['path'], '/') . '/';

        // Check file size
        if ($_FILES['file']['size'] > $this->config['security']['max_upload_size']) {
            return "File size exceeds maximum allowed size.";
        }

        // Sanitize filename
        $filename = preg_replace("/[^a-zA-Z0-9._-]/", "", $filename);

        // Move uploaded file
        if (move_uploaded_file($_FILES['file']['tmp_name'], $path . $filename)) {
            return htmlentities($filename) . " successfully uploaded to " . htmlentities($path);
        } else {
            return "Error uploading " . htmlentities($filename);
        }
    }
}
