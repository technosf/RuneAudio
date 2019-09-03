<script src="assets/js/vendor/jquery-2.1.0.min.js"></script>
<script src="/assets/js/vendor/pushstream.min.<?=$time?>.js"></script>
<script src="assets/js/info.<?=$time?>.js"></script>
<script>
count = 0;
	
pushstream = new PushStream( { modes: 'websocket' } );
pushstream.addChannel( 'runonce' );
pushstream.connect();
pushstream.onmessage = function( data ) {
	location.reload();
}

function clearRunonce() {
	pushstream.disconnect();
	$.post( 'commands.php', { bash: [
		  "sed -i '/runonce.php/ d' /srv/http/indexbody.php"
		, 'rm -f /srv/http/runonce.php'
		, 'curl -s -X POST "http://localhost/pub?id=runonce" -d 1'
	] }	);
}
function getStatus() {
	count++;
	$.post( 'commands.php', { bash: 'systemctl is-active hostapd' }, function( data ) {
		if ( data === 'active' || count === 3 ) {
			location.href = 'indexsettings.php?p=network';
		} else {
			waitAccesspoint();
		}
	} );
}
function waitAccesspoint() {
	info( {
		  icon        : 'rune'
		, title       : 'RuneAudio'
		, message     : 'RPi access point is starting.'
					   +'<br>Please wait a few seconds ...'
		, ok          : getStatus
	} );	
}
info( {
	  icon        : 'rune'
	, title       : 'RuneAudio'
	, message     : 'Welcome!'
				   +'<br><br>Show <wh>Web user interface</wh> URL'
				   +'<br>for remote device connection?'
	, cancellabel : 'Skip'
	, cancel      : function() {
		clearRunonce();
		location.reload();
	}
	, ok          : function() {
		clearRunonce();
		getStatus();
	}
} );
</script>
</body>
</html>
<?php exit();?>
