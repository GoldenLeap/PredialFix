<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    @vite(['resources/js/app.ts'])
    @inertiaHead
</head>

<body>
    @inertia
    @if(session('play_sound'))
        <script>
            window.addEventListener('DOMContentLoaded', function () {
                const audio = new Audio('{{ Vite::asset("resources/sounds/nuossa.mp3") }}');
                audio.play().catch(() => { });
            });
        </script>
    @endif
</body>

</html>