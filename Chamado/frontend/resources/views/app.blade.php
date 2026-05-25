<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    @vite(['resources/js/app.ts'])
    @inertiaHead

</head>
<body>
    @inertia
    
</body>
</html>
@if(session('play_sound'))
<script>
    window.onload = function() {
        const audio = new Audio(assets("/sounds/nuossa.mp3"));
        audio.play().catch(error => {
            console.log("O navegador bloqueou o som. O usuário precisa interagir com a página primeiro.");
        });
    }
</script>
@endif