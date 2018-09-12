<?php
$file = "/etc/airtime/airtime.conf.tmp";
if (file_exists($file)) {
	return shell_exec('service airtime-media-monitor start && service airtime-playout restart && service airtime-liquidsoap restart');
}

$db = getenv("DB_PORT");
if (empty($db)) {
	$db = getenv("DB");
}

$rabbit = getenv("RABBIT_PORT");
if (empty($rabbit)) {
	$rabbit = getenv("RABBIT");
}

if (empty($rabbit) || empty($db)) {
	return;
}

$apikey = getenv('AIRTIME_API_KEY');

function write_php_ini($array, $file) {
	$res = array();
	foreach ($array as $key => $val) {
		if (is_array($val)) {
			$res[] = "[$key]";
			foreach ($val as $skey => $sval) {
				$res[] = "$skey = " . (is_numeric($sval) ? $sval : '' . $sval . '');
			}

		} else {
			$res[] = "$key = " . (is_numeric($val) ? $val : '' . $val . '');
		}
	}
	safefilerewrite($file, implode("\r\n", $res));
}

function safefilerewrite($fileName, $dataToSave) {
	if ($fp = fopen($fileName, 'w')) {
		$startTime = microtime(TRUE);
		do {
			$canWrite = flock($fp, LOCK_EX);
			if (!$canWrite) {
				usleep(round(rand(0, 100) * 1000));
			}

		} while ((!$canWrite) and ((microtime(TRUE) - $startTime) < 5));
		if ($canWrite) {
			fwrite($fp, $dataToSave);
			flock($fp, LOCK_UN);
		}
		fclose($fp);
	}
}
function generateRandomString($length = 10) {
	$characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	$charactersLength = strlen($characters);
	$randomString = '';
	for ($i = 0; $i < $length; $i++) {
		$randomString .= $characters[rand(0, $charactersLength - 1)];
	}
	return $randomString;
}
$data = array();

$databaseDefults = array('host' => 'db', 'user' => 'postgres', 'pass' => 'mysecretpassword', 'path' => '/airtime', 'port' => 5672);
$databaseData = array_merge($databaseDefults, parse_url($db));
$data['database'] = array(
	"dbuser" => $databaseData['user'],
	"dbpass" => $databaseData['pass'],
	"dbname" => trim($databaseData['path'], '/'),
	"host" => $databaseData['host'],
);

$databaseDefults = array('host' => 'db', 'user' => 'guest', 'pass' => 'guest', 'path' => '/', 'port' => 5672);
$databaseData = array_merge($databaseDefults, parse_url($rabbit));
$data['rabbitmq'] = array(
	"user" => $databaseData['user'],
	"password" => $databaseData['pass'],
	"host" => $databaseData['host'],
	"port" => $databaseData['port'],
	"vhost" => $databaseData['path'],
);

// $data['general'] = array(
// 	"api_key" => empty($apikey) ? generateRandomString(20) : $apikey,
// 	"web_server_user" => 'www-data',
// 	"airtime_dir" => '/usr/share/airtime',
// 	"base_url" => 'localhost',
// 	"base_port" => '80',
// 	"base_dir" => '/',
// 	"cache_ahead_hours" => 1,
// );

// $data['media-monitor'] = array(
// 	"check_filesystem_events" => 5,
// 	"check_airtime_events" => 30,
// 	"touch_interval" => 5,
// 	"chunking_number" => 450,
// 	"request_max_wait" => 3.0,
// 	"rmq_event_wait" => 0.1,
// 	"logpath" => "/var/log/airtime/media-monitor/media-monitor.log",
// 	"index_path" => "/var/tmp/airtime/media-monitor/last_index",
// );

// $data['pypo'] = array(
// 	"api_client" => 'airtime',
// 	"cache_dir" => '/var/tmp/airtime/pypo/cache/',
// 	"file_dir" => '/var/tmp/airtime/pypo/files/',
// 	"tmp_dir" => '/var/tmp/airtime/pypo/tmp/',
// 	"cache_base_dir" => '/var/tmp/airtime/pypo',
// 	"log_base_dir" => "/var/log/airtime",
// 	"pypo_log_dir" => "/var/log/airtime/pypo",
// 	"liquidsoap_log_dir" => "/var/log/airtime/pypo-liquidsoap",
// 	"ls_host" => "airtime",
// 	"ls_port" => "1234",
// 	"poll_interval" => 3600,
// 	"push_interval" => 1,
// 	"cue_style" => "pre",
// 	"record_bitrate" => 256,
// 	"record_samplerate" => 44100,
// 	"record_channels" => 2,
// 	"record_sample_size" => 16,
// 	"record_file_type" => "ogg",
// 	"base_recorded_files" => "/var/tmp/airtime/show-recorder/",
// );

// $data["monit"] = array(
// 	"monit_user" => "guest",
// 	"monit_password" => "airtime",
// );

// $data["soundcloud"] = array(
// 	"connection_retries" => 3,
// 	"time_between_retries" => 60,
// );
write_php_ini($data, $file);
