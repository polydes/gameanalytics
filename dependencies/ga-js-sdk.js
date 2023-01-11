window.GameAnalytics=window.GameAnalytics||function(){(GameAnalytics.q=GameAnalytics.q||[]).push(arguments)};

var sdkScript = document.createElement('script');
sdkScript.src = 'http://download.gameanalytics.com/js/GameAnalytics-4.4.5.min.js';
sdkScript.setAttribute("type", "text/javascript");
sdkScript.async = true;
document.head.appendChild(sdkScript);

GameAnalytics("setEnabledEventSubmission", false);

//https://stackoverflow.com/questions/63697348/how-do-i-know-whether-my-user-is-from-eu-countries
const EU_TIMEZONES = [
	'Europe/Vienna',
	'Europe/Brussels',
	'Europe/Sofia',
	'Europe/Zagreb',
	'Asia/Famagusta',
	'Asia/Nicosia',
	'Europe/Prague',
	'Europe/Copenhagen',
	'Europe/Tallinn',
	'Europe/Helsinki',
	'Europe/Paris',
	'Europe/Berlin',
	'Europe/Busingen',
	'Europe/Athens',
	'Europe/Budapest',
	'Europe/Dublin',
	'Europe/Rome',
	'Europe/Riga',
	'Europe/Vilnius',
	'Europe/Luxembourg',
	'Europe/Malta',
	'Europe/Amsterdam',
	'Europe/Warsaw',
	'Atlantic/Azores',
	'Atlantic/Madeira',
	'Europe/Lisbon',
	'Europe/Bucharest',
	'Europe/Bratislava',
	'Europe/Ljubljana',
	'Africa/Ceuta',
	'Atlantic/Canary',
	'Europe/Madrid',
	'Europe/Stockholm'
];

var tz_script = document.createElement('script');
tz_script.src = 'https://cdnjs.cloudflare.com/ajax/libs/jstimezonedetect/1.0.7/jstz.min.js';
tz_script.setAttribute("type", "text/javascript");
tz_script.async = true;

tz_script.onload = function(e) {
	var tz = jstz.determine().name();
	console.log(tz);
	if(!EU_TIMEZONES.includes(tz)) {
		GameAnalytics("setEnabledEventSubmission", true);
	}
}

document.head.appendChild(tz_script);
