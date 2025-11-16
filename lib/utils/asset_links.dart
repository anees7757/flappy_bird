class Assets {
  // Base directories
  static const _baseImages = 'assets/images';

  // Subdirectories for images
  static const _birdDir = '$_baseImages/bird';
  static const _yellowBirdDir = '$_birdDir/yellow';
  static const _redBirdDir = '$_birdDir/red';
  static const _blueBirdDir = '$_birdDir/blue';
  static const _pipeDir = '$_baseImages/pipe';
  static const _numbersDir = '$_baseImages/numbers';
  static const _componentsDir = '$_baseImages/components';
  static const _backgroundDir = '$_baseImages/background';

  // Backgrounds
  static const backgroundDay = '$_backgroundDir/background-day.png';
  static const backgroundNight = '$_backgroundDir/background-night.png';
  static const ground = '$_backgroundDir/base.png';
  static const backgrounds = [backgroundDay, backgroundNight];

  // Birds
  static const yellowBirdUpflap = '$_yellowBirdDir/yellowbird-upflap.png';
  static const yellowBirdMidflap = '$_yellowBirdDir/yellowbird-midflap.png';
  static const yellowBirdDownflap = '$_yellowBirdDir/yellowbird-downflap.png';

  static const redBirdUpflap = '$_redBirdDir/redbird-upflap.png';
  static const redBirdMidflap = '$_redBirdDir/redbird-midflap.png';
  static const redBirdDownflap = '$_redBirdDir/redbird-downflap.png';

  static const blueBirdUpflap = '$_blueBirdDir/bluebird-upflap.png';
  static const blueBirdMidflap = '$_blueBirdDir/bluebird-midflap.png';
  static const blueBirdDownflap = '$_blueBirdDir/bluebird-downflap.png';

  static const birds = [yellowBirdMidflap, redBirdMidflap, blueBirdMidflap];

  static const yellowBird = [
    yellowBirdUpflap,
    yellowBirdMidflap,
    yellowBirdDownflap
  ];
  static const redBird = [redBirdUpflap, redBirdMidflap, redBirdDownflap];
  static const blueBird = [blueBirdUpflap, blueBirdMidflap, blueBirdDownflap];

  static const birdAnimations = [yellowBird, redBird, blueBird];

  // Pipes
  static const pipeBottom = '$_pipeDir/pipe_bottom.png';
  static const pipeTop = '$_pipeDir/pipe_top.png';

  // UI components
  static const gameOver = '$_componentsDir/gameover.png';
  static const selectBirdMenu = '$_componentsDir/select_bird.png';
  static const message = '$_componentsDir/message.png';
  static const playButton = '$_componentsDir/play_btn.png';

  // Logo
  static const logo = '$_baseImages/logo.png';

  // Numbers helper
  static String number(String num) => '$_numbersDir/$num.png';

  // Audio files
  static const die = 'die.wav';
  static const hit = 'hit.wav';
  static const point = 'point.wav';
  static const swoosh = 'swoosh.wav';
  static const wing = 'wing.wav';
}
