<?php
/* 
$_POST["list_emails"] = "vincent.huss@gmail.com";
$_POST["list_articles"] = '[{"url":"http://www.google.com","tags":"game,nature","content":"D\'un longueur de 8 km, ce sentier - balisé par un anneau bleu - traverse les villages d\'Ittlenheim, Neugartheim et Wintzenheim-Kochersberg en empruntant les rues des villages et les chemins ruraux. Il vous permettra de re(découvrir) le Mont-Kochersberg et ses environs ainsi que le patrimoine architectural et historique du Kochersberg. Vous pourrez notamment observer un pressoir à raison ou encore un ancien lavoir à Wintzenheim-Kochersberg.\r\n\tIl offre tout au long du parcours des panoramas magnifiques sur la plaine d\'Alsace, Strasbourg et sa cathédrale, les Vosges et la Forêt-Noire.","img_thumb":"article-7.jpg","title":"Sentier : zajrh azoiery aozirey azoiru aoiz re découverte du Kochersberg","city":"Neugartheim Ittlenheim","date":"","address":"67370 Neugartheim Ittlenheim\r\n\tFrance","id":"7"},{"url":"http://www.android.com","tags":"game,food","content":"Le parc éco-pédagogique situé au bord de l\'Avenheimerbach comprend une aire de jeux, un espace pédagogique, un biotope, un parcours de santé, une mare et une aire de pique-nique. L\'ensemble s\'étend sur une surface de 4 hectares.","img_thumb":"article-8.jpg","title":"Aire de jeux","city":"Truchtersheim","date":"","address":"rue Godofredo Perez\r\n\t67370 Truchtersheim\r\n\tFrance","id":"8"},{"url":"http://www.google.com","tags":"game,nature","content":"D\'un longueur de 8 km, ce sentier - balisé par un anneau bleu - traverse les villages d\'Ittlenheim, Neugartheim et Wintzenheim-Kochersberg en empruntant les rues des villages et les chemins ruraux. Il vous permettra de re(découvrir) le Mont-Kochersberg et ses environs ainsi que le patrimoine architectural et historique du Kochersberg. Vous pourrez notamment observer un pressoir à raison ou encore un ancien lavoir à Wintzenheim-Kochersberg.\r\n\tIl offre tout au long du parcours des panoramas magnifiques sur la plaine d\'Alsace, Strasbourg et sa cathédrale, les Vosges et la Forêt-Noire.","img_thumb":"article-7.jpg","title":"Sentier : zajrh azoiery aozirey azoiru aoiz re découverte du Kochersberg","city":"Neugartheim Ittlenheim","date":"","address":"67370 Neugartheim Ittlenheim\r\n\tFrance","id":"7"},{"url":"http://www.google.com","tags":"game,nature","content":"D\'un longueur de 8 km, ce sentier - balisé par un anneau bleu - traverse les villages d\'Ittlenheim, Neugartheim et Wintzenheim-Kochersberg en empruntant les rues des villages et les chemins ruraux. Il vous permettra de re(découvrir) le Mont-Kochersberg et ses environs ainsi que le patrimoine architectural et historique du Kochersberg. Vous pourrez notamment observer un pressoir à raison ou encore un ancien lavoir à Wintzenheim-Kochersberg.\r\n\tIl offre tout au long du parcours des panoramas magnifiques sur la plaine d\'Alsace, Strasbourg et sa cathédrale, les Vosges et la Forêt-Noire.","img_thumb":"article-7.jpg","title":"Sentier : zajrh azoiery aozirey azoiru aoiz re découverte du Kochersberg","city":"Neugartheim Ittlenheim","date":"","address":"67370 Neugartheim Ittlenheim\r\n\tFrance","id":"7"}]';
 */



define("EMAIL_SENDER", "vinc_77@hotmail.com");
define("NAME_SENDER", "Kochersberg Alsace");
define("PATH_SERVER", "http://appinstrasbourg.com/custom/stamtish/php/");




$dyn_content = "";
$dyn_content .= '<table style="padding-left:0;padding-right:0;padding-top:0;padding-bottom:0;margin-left:0;margin-bottom:0;margin-top:0;margin-right:0;width:100%;" border="0" border-spacing="0" cellpadding="0" cellspacing="0" align="center">';

$data = json_decode($_POST["list_articles"], true);
//var_dump($data);

$counter = 0;
foreach($data as $obj) {

	
	
	if (!isset($obj["url"])) $obj["url"] = "";
	
	
	$dyn_content .= "<tr style='height:120px;'><td style='text-align:center;'>";
	$dyn_content .= "<a style='text-decoration:none;' href='".$obj["url"]."'>\n";
	
	
	$dyn_content .= '<table style="background-image:url(\''.PATH_SERVER.'mails/images/item-bg.png\');width:656px;height:97px;background-repeat:no-repeat;margin-left:auto;margin-right:auto;text-align:left;">';
	
	$dyn_content .= "<tr>";
	
	$dyn_content .= "<td style='padding-left:40px;'>";
	
	$dyn_content .= "<img src='".$obj["img_thumb"]."' style='width:55px;height:55px;margin-top:5px;' />\n";
	
	$dyn_content .= "</td>";
	
	
	$dyn_content .= "<td>";
	$dyn_content .= "<table style='margin-left:-20px;margin-top:0px;'>";
	
	$dyn_content .= "<tr><td>\n";
	$dyn_content .= "<div style='color:white;font-size:16px;font-weight:bold;width:410px;'>".$obj["title"]."</div>\n";
	$dyn_content .= "</td></tr>\n";
	
	$dyn_content .= "<tr><td>";
	$dyn_content .= "<div style='color:white;font-size:14px;width:410px;'>".$obj["city"]."</div>";
	$dyn_content .= "</td></tr>";
	
	$dyn_content .= "</table>";
	$dyn_content .= "</td>";
	
	
	$dyn_content .= "</tr>";
	$dyn_content .= "</table>";
	
	$dyn_content .= "</a>\n";
	$dyn_content .= "</td></tr>";
	
	/* 
	$dyn_content .= "<tr><td style='text-align:center;'>";
	$dyn_content .= "salut";
	$dyn_content .= "</td></tr>";
	 */
	
	
	$counter++;
}


$dyn_content .= "</table>";

sendMail($dyn_content);




function sendMail($dyn_content)
{
	require_once("classes/phpmailer/class.phpmailer.php");
	require_once("classes/class.DataMailer.php");
	
	
	$sd = new dataMailer();
	$sd->setSender_email(EMAIL_SENDER);
	$sd->setSender_name(NAME_SENDER);
	$sd->setTpl("mails/send.tpl");
	
	$list_emails = explode(",", $_POST["list_emails"]);
	foreach($list_emails as $email){
		
		$sd->addDest_email($email, $email);
	}
	
	$sd->setObject_email("Votre selection - Kochersberg Alsace");
	
	$sd->addVariable("dyn_content", $dyn_content);
	$sd->addVariable("path_server", PATH_SERVER);
	
	
	$sd->send();
	
	//$sd->show();
	echo("get _error : ".$sd->getMsgError());
	
	
	
	
}


?>