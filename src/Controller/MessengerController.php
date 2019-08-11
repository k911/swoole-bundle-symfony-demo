<?php
declare(strict_types=1);

namespace App\Controller;

use App\Message\LuckyNumber;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Messenger\MessageBusInterface;
use Symfony\Component\Routing\Annotation\Route;

final class MessengerController
{

    /**
     * @Route(path="/messenger",methods={"GET"})
     * @param MessageBusInterface $bus
     * @return Response
     * @throws \Exception
     */
    public function luckyNumberCli(MessageBusInterface $bus): Response
    {
        $luckyNumber = \random_int(0, 100);

        $bus->dispatch(new LuckyNumber($luckyNumber));

        return new Response(
            '<html><body><h1>Hello world!</h1><h2>Lucky number sent to your console: ' . $luckyNumber . '</h2><i>Go check it!</i></body></html>'
        );
    }

}
