<script src="assets/js/vendor/jquery-2.1.0.min.js"></script>
<script src="/assets/js/vendor/pushstream.min.<?=$time?>.js"></script>
<script src="assets/js/info.<?=$time?>.js"></script>
<script>
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
		location.href = 'indexsettings.php?p=network';
	}
} );
</script>
</body>
</html>
<?php exit();?>
