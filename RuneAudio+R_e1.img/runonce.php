<script src="assets/js/vendor/jquery-2.1.0.min.js"></script>
<script src="assets/js/info.<?=$time?>.js"></script>
<script>
function clearRunonce() {
	$.post( 'commands.php', { bash: [
		  "sed -i '/runonce.php/ d' /srv/http/indexbody.php"
		, 'rm -f /srv/http/runonce.php'
	] }	);
}
info( {
	  icon        : 'rune'
	, title       : 'RuneAudio'
	, message     : 'Welcome to RuneAudio'
				   +'<br><br>Show <wh>Web user interface</wh> connection
				   +'<br>for remote devices?'
	, cancellabel : 'No'
	, cancel      : function() {
		clearRunonce();
		location.reload();
	}
	, ok          : function() {
		clearRunonce();
		location.href='indexsettings.php?p=network';
	}
} )
setTimeout( function() {
	clearRunonce();
	$( '#infoCancel' ).click();
}, 15000 );
</script>
</body>
</html>
<?php exit();?>
