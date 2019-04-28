<?php
declare(strict_types=1);

namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

final class DefaultController
{

    /**
     * @Route(path="/",methods={"GET"})
     * @return Response
     * @throws \Exception
     */
    public function index(): Response
    {
        $number = \random_int(0, 100);

        return new Response(
            '<html><body><h1>Hello world!</h1><h2>Lucky number: ' . $number . '</h2></body></html>'
        );
    }

}
