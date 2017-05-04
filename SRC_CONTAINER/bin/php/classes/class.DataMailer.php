<?php
class datamailer{
	
	//INIT
	private $object_email;
	private $sender_email;
	private $sender_name;
	private $path;                    
	private $tpl;                     //nom du fichier tpl
	private $defineErrors = 1;        //0,1,2
	private $msgError;       
	
	private $vars = array();
	private $addDest = array();
	
	private $list_attachement = array();
	
	
	//SET
	public function setObject_email($v)
	{
		$this->object_email = $v;
	}
	public function setSender_email($v)
	{
		$this->sender_email = $v;
	}
	public function setSender_name($v)
	{
		$this->sender_name = $v;
	}
	public function setTpl($v)
	{
		$this->tpl = $v;
	}
	public function setDefineErrors($v)
	{
		$this->defineErrors = $v;
	}
	public function addAttachment($_path, $_name, $_encoding, $_type)
	{
		$attachements = $this->list_attachement;
		$attachements[] = array($_path, $_name, $_encoding, $_type);
		$this->list_attachement = $attachements;
	}
	
	
	//GET
	public function getMsgError()
	{
		return $this->msgError;
	}
	
	//METHODS
	public function addVariable($_key, $_value) 
	{
		$this->vars[$_key] = $_value;
	}
	public function addDest_email($_email, $_name)
	{
		$this->addDest[$_name] = $_email;
	}
	public function send()
	{
		if($this->testConfig()) 
		{
			$htmlcontent = file_get_contents($this->tpl);
			$htmlcontent = utf8_decode($this->convertVars($htmlcontent, "{{", "}}", $this->vars));
			$mailer = new PHPMailer();
			$mailer->From = $this->sender_email;
			$mailer->FromName = $this->sender_name;
			
			foreach($this->addDest as $_name=>$_email)
				$mailer->AddAddress($_email, $_name);
				
			foreach($this->list_attachement as $_key=>$_tab){
				echo("AddAttachment(".$_tab[0].", ".$_tab[1].")");
				$mailer->AddAttachment($_tab[0], $_tab[1], $_tab[2], $_tab[3]);
			}
			
			$mailer->Subject = utf8_decode($this->object_email);
			$mailer->AltBody = 'To view the message, please use an HTML compatible emailer viewer!';
			$mailer->MsgHTML($htmlcontent);
			if(!$mailer->Send()) 
				$this->displayErrors(5);
			else 
				$this->displayErrors(6);
		}
	}
	
	
	public function show() 
	{
		if($this->testConfig()) 
		{
			$htmlcontent = utf8_decode(file_get_contents($this->tpl));
			$htmlcontent = $this->convertVars($htmlcontent, "{{", "}}", $this->vars);
			echo $htmlcontent;
		}
	}
	private function testConfig() 
	{
		if(!@is_file($this->tpl))
			$this->displayErrors(0);
		else if($this->sender_email == "")
			$this->displayErrors(1);
		else if($this->sender_name == "")
			$this->displayErrors(2);
		else if(empty($this->addDest))
			$this->displayErrors(3);
		else if($this->object_email == "")
			$this->displayErrors(4);
		else
			return true;
	}
	private function displayErrors($numError) {
		switch($this->defineErrors)
		{
			case 1:
				$this->msgError = $numError;
			break;
			case 2:
				if($numError == 0)
					$this->msgError = MAIL_ERROR_CONFIG_TPL;
				if($numError == 1)
					$this->msgError = MAIL_ERROR_CONFIG_SENDER_EMAIL;
				if($numError == 2)
					$this->msgError = MAIL_ERROR_CONFIG_SENDER_NAME;
				if($numError == 3)
					$this->msgError = MAIL_ERROR_CONFIG_DEST;
				if($numError == 4)
					$this->msgError = MAIL_ERROR_CONFIG_OBJECT_EMAIL;
				if($numError == 5)
					$this->msgError = MAIL_ERROR_SEND_EMAIL;
				if($numError == 6)
					$this->msgError = MAIL_SEND_OK;
			break;
			default:
				$this->msgError = "";
			break;
		}
	}
	private function convertVars($str, $key_start, $key_end, $tab=0, $showError=false)
	{
		if($tab==0) $tab = $GLOBALS;
		while(true)
		{
			$ind0 = strpos($str, $key_start) + strlen($key_start);;
			$ind1 = strpos($str, $key_end);
			if($ind1==false) break;
			$key = substr($str, $ind0, $ind1-$ind0);
			if($showError) $str = str_replace($key_start.$key.$key_end, $tab[$key], $str);
			else @$str = str_replace($key_start.$key.$key_end, $tab[$key], $str);
		}
		return $str;
	}
}
?>