#!/usr/bin/php
<?php
/**
 * telegram-bot.php
 * Sends Nagios alerts to Telegram, with proper newlines and formatting
 * Usage:
 *   php telegram-bot.php "<chat_id>" "<bot_token>" "<message>"
 */

if ($argc < 4) {
    fwrite(STDERR, "Usage: php telegram-bot.php <chat_id> <bot_token> <message>\n");
    exit(1);
}

$chat_id   = $argv[1];
$bot_token = $argv[2];
$message   = $argv[3];

// Decode literal '\n' sequences into real newlines
$message = str_replace("\\n", "\n", $message);

// Telegram API endpoint
$api_url = "https://api.telegram.org/bot{$bot_token}/sendMessage";

// Prepare POST data
$post_fields = [
    'chat_id' => $chat_id,
    'text' => $message,
    'parse_mode' => 'HTML', // You can change to 'MarkdownV2' if desired
];

// Send message
$ch = curl_init();
curl_setopt_array($ch, [
    CURLOPT_URL => $api_url,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $post_fields,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT => 10,
]);

$response = curl_exec($ch);
$http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);

if ($response === false || $http_code != 200) {
    fwrite(STDERR, "Error sending message: " . curl_error($ch) . "\n");
    fwrite(STDERR, "HTTP Code: $http_code\nResponse: $response\n");
    curl_close($ch);
    exit(1);
}

curl_close($ch);
exit(0);
