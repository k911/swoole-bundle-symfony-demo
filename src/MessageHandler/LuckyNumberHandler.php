<?php
declare(strict_types=1);

namespace App\MessageHandler;

use App\Message\LuckyNumber;
use Symfony\Component\Messenger\Handler\MessageHandlerInterface;

final class LuckyNumberHandler implements MessageHandlerInterface
{

    public function __invoke(LuckyNumber $luckyNumber)
    {
        echo "[Console] Your lucky number is: $luckyNumber" . PHP_EOL;
    }

}
